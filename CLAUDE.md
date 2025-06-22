# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

```bash
# Setup and Installation
bin/setup                    # Initial setup script
bundle install              # Install gems
bin/rails db:migrate        # Run database migrations

# Development Server
bin/rails server            # Start server on port 3000
bin/dev                     # Development script
bin/rails console          # Rails console for debugging

# Testing
bundle exec rspec           # Run all tests
bundle exec rspec spec/requests/  # Run API tests only
bundle exec rspec spec/models/    # Run model tests only

# Code Quality
bin/brakeman               # Security vulnerability scan
bin/rubocop                # Code style check (Rails Omakase style)

# Database Operations
bin/rails db:create         # Create database
bin/rails db:seed          # Seed database with sample data
bin/rails db:reset         # Drop, create, migrate, and seed
```

## Architecture Overview

This is a **Rails 8.0.2 API-only application** for task management with user authentication.

### Technology Stack
- **Ruby 3.4.4** 
- **SQLite3** database for all environments
- **Rails 8 Solid Stack**: solid_cache, solid_queue, solid_cable
- **Token-based authentication** using UUID tokens
- **RSpec + FactoryBot** for testing
- **Docker** ready for production

### Core Models
- **User**: Authentication with `has_secure_password`, has many tasks, generates UUID token
- **Task**: Belongs to user, has content and completed status

### API Authentication
All authenticated endpoints require `Authorization: Bearer <token>` header. Users receive tokens via POST `/auth` (login) or POST `/users` (registration).

### Key API Endpoints
```
POST /auth          # Login (returns token)
POST /users         # Register (returns token)
GET  /tasks         # List user's tasks (authenticated)
POST /tasks         # Create task (authenticated)
PATCH /tasks/:id    # Update task (authenticated)
DELETE /tasks/:id   # Delete task (authenticated)
```

### Testing Notes
- Tests are written in **Japanese** - this is intentional for this project
- Uses FactoryBot for test data: `create(:user)`, `create(:task)`
- SimpleCov generates coverage reports in `/coverage/`
- Authentication helper: `auth_headers(user)` provides Bearer token headers

### Configuration Notes
- **Open CORS policy** - allows requests from any domain
- **API-only mode** - no views or assets pipeline
- **Transactional fixtures** enabled for tests
- **RuboCop Rails Omakase** style guide enforced