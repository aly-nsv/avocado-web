// PostgreSQL database connection for FL511 incidents
import { Pool, PoolClient, QueryResult } from 'pg';

// Database configuration from environment variables
const dbConfig = {
  host: process.env.DATABASE_HOST || '34.42.128.70',
  database: process.env.DATABASE_NAME || 'fl511_incidents',
  user: process.env.DATABASE_USER || 'fl511_user',
  password: process.env.DATABASE_PASSWORD,
  port: parseInt(process.env.DATABASE_PORT || '5432'),
  ssl: process.env.DATABASE_SSL === 'true',
  max: 20, // Maximum number of clients in the pool
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
};

class DatabaseConnection {
  private static instance: DatabaseConnection;
  private pool: Pool;

  private constructor() {
    this.pool = new Pool(dbConfig);
    
    // Handle pool errors
    this.pool.on('error', (err) => {
      console.error('Unexpected error on idle client', err);
    });

    this.pool.on('connect', () => {
      console.log('Connected to PostgreSQL database');
    });
  }

  public static getInstance(): DatabaseConnection {
    if (!DatabaseConnection.instance) {
      DatabaseConnection.instance = new DatabaseConnection();
    }
    return DatabaseConnection.instance;
  }

  /**
   * Execute a query with optional parameters
   */
  public async query(text: string, params?: any[]): Promise<QueryResult<any>> {
    const client = await this.pool.connect();
    try {
      const result = await client.query(text, params);
      return result;
    } finally {
      client.release();
    }
  }

  /**
   * Get a client from the pool for transactions
   */
  public async getClient(): Promise<PoolClient> {
    return await this.pool.connect();
  }

  /**
   * Execute multiple queries in a transaction
   */
  public async transaction<T>(callback: (client: PoolClient) => Promise<T>): Promise<T> {
    const client = await this.pool.connect();
    try {
      await client.query('BEGIN');
      const result = await callback(client);
      await client.query('COMMIT');
      return result;
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Close all connections in the pool
   */
  public async close(): Promise<void> {
    await this.pool.end();
  }

  /**
   * Test the database connection
   */
  public async testConnection(): Promise<boolean> {
    try {
      const result = await this.query('SELECT NOW() as current_time');
      console.log('Database connection test successful:', result.rows[0]);
      return true;
    } catch (error) {
      console.error('Database connection test failed:', error);
      return false;
    }
  }
}

export const db = DatabaseConnection.getInstance();
export default db;