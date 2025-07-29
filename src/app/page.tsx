'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useStateMap } from '@/components/providers/StateMapProvider';

export default function HomePage() {
  const router = useRouter();
  const { selectedState } = useStateMap();

  // Redirect to state-scoped route
  useEffect(() => {
    router.replace(`/${selectedState.code}/map`);
  }, [router, selectedState.code]);

  return (
    <div className="flex items-center justify-center h-screen bg-background">
      <div className="text-lg text-neutral-400 animate-pulse">Redirecting...</div>
    </div>
  );
}