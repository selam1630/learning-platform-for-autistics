# Architecture Notes

## Product Areas

### 1. Child Learning

- Visual cards and guided lesson flows
- Audio prompts in Amharic
- Reward mechanics such as stars and progress celebration
- Offline access to downloaded lessons and assets

### 2. Parent Community

- Topic-based discussions
- Text and voice posting support
- Moderation workflow for safety and quality

### 3. AI Parent Assistant

- Expert-reviewed Q&A flows for common autism support questions
- Guardrails that avoid diagnosis claims and encourage professional support when needed
- Offline bundle for common questions

## Backend Modules

- `auth`: parent login and session management
- `users`: caregiver profiles and child profiles
- `lessons`: modules, activities, rewards, progress
- `community`: posts, comments, moderation
- `assistant`: curated answers and future AI integrations

## Initial API Shape

- `GET /api/health`
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/lessons/modules`
- `GET /api/community/posts`
- `POST /api/community/posts`
- `POST /api/assistant/ask`

## Data Priorities

- Parent user account
- Child profile
- Lesson module metadata
- Progress tracking
- Community post and comment
- Curated assistant answer entry

## Persistence

- `MongoDB` is the primary database
- `Prisma` is the backend ORM and schema source of truth
- The Prisma schema lives in `backend/prisma/schema.prisma`
