# Ethiopia Autism Learning & Support App

An offline-friendly learning and support platform for Ethiopian children with autism and their families.

## Stack

- `mobile/`: Flutter app for Android-first delivery
- `backend/`: Node.js + Express API
- `MongoDB`: primary database

## MVP Scope

- Child learning modules for communication, emotions, and routines
- Parent guidance content in localized, simple language
- Community discussion board for parents and caregivers
- AI assistant with predefined expert-backed question flows

## Monorepo Structure

```text
.
├── backend
├── docs
└── mobile
```

## Getting Started

### Backend

```bash
cd backend
npm install
npm run dev
```

### Mobile

The Flutter app scaffold still needs to be generated with the local Flutter SDK. If the SDK requires elevated permissions on this machine, run that step after approval.

## Near-Term Build Order

1. Finish the Flutter mobile scaffold
2. Connect the app to the backend health endpoint
3. Add authentication for parents/caregivers
4. Build the first learning module
5. Add offline lesson caching and local audio assets

