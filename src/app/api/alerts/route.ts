import { NextResponse } from 'next/server';
import { Alert } from '@/types/dashboard';

const MOCK_ALERTS: Alert[] = [
  {
    id: 'alert-001',
    severity: 'critical',
    location: 'I-94 EB @ Exit 180 (Harper Ave)',
    description: 'Multi-vehicle collision blocking 2 right lanes. Emergency services on scene. Heavy delays expected.',
    timestamp: '2025-07-29T14:30:00Z',
    timeAgo: '5 min ago',
    coordinates: [-82.9219, 42.4584],
  },
  {
    id: 'alert-002',
    severity: 'warning', 
    location: 'I-75 SB @ 8 Mile Road',
    description: 'Construction zone active. Lane restrictions in effect. Expect 15-minute delays during peak hours.',
    timestamp: '2025-07-29T13:45:00Z',
    timeAgo: '45 min ago',
    coordinates: [-83.0458, 42.3314],
  },
  {
    id: 'alert-003',
    severity: 'info',
    location: 'M-10 NB @ Grand River Ave',
    description: 'Traffic camera maintenance scheduled. Camera feed temporarily unavailable.',
    timestamp: '2025-07-29T12:15:00Z',
    timeAgo: '2 hours ago',
    coordinates: [-83.0735, 42.3364],
  },
  {
    id: 'alert-004',
    severity: 'critical',
    location: 'I-696 WB @ I-75 Interchange',
    description: 'Hazardous material spill reported. All lanes closed. Hazmat team responding.',
    timestamp: '2025-07-29T14:45:00Z',
    timeAgo: '2 min ago',
    coordinates: [-83.0458, 42.4584],
  },
  {
    id: 'alert-005',
    severity: 'warning',
    location: 'US-23 SB @ M-14 Junction',
    description: 'Heavy commercial vehicle traffic detected. Reduced speeds in effect.',
    timestamp: '2025-07-29T14:00:00Z',
    timeAgo: '30 min ago',
    coordinates: [-83.7430, 42.2814],
  },
  {
    id: 'alert-006',
    severity: 'info',
    location: 'I-275 NB @ Ford Road',
    description: 'Weather advisory: Light rain expected. Drive with caution, roads may be slippery.',
    timestamp: '2025-07-29T11:30:00Z',
    timeAgo: '3 hours ago',
    coordinates: [-83.2813, 42.3150],
  },
];

export async function GET() {
  // Simulate API delay for realistic experience
  await new Promise(resolve => setTimeout(resolve, 300));
  
  return NextResponse.json(MOCK_ALERTS);
}