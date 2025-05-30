# Contributing to ansible-updates

## Code Standards

### Ansible Best Practices

1. **Idempotency**: All playbooks and roles must be idempotent
2. **Variables**: Use descriptive variable names with proper scoping
3. **Tags**: Implement meaningful tags for all tasks
4. **Documentation**: Document all roles and playbooks

### Git Workflow

1. Create a feature branch from `main`
2. Make your changes
3. Test your changes with Molecule
4. Submit a pull request

### Testing Requirements

- All roles must have Molecule tests
- Playbooks should be tested in a development environment
- Use ansible-lint for code quality

### Commit Messages

Follow conventional commits:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation
- `refactor:` for code refactoring
- `test:` for tests
- `chore:` for maintenance
