# Contributing to retail SQL Case Study

Thank you for your interest in contributing to this project! This document provides guidelines for contributions.

## How to Contribute

### 1. Fork the Repository
```bash
# Click "Fork" button on GitHub
# Clone your fork
git clone https://github.com/sharanit/retail-sql-case-study.git
cd retail-sql-case-study
```

### 2. Create a Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-fix-name
```

### 3. Make Your Changes

#### Adding New SQL Queries
- Follow the existing naming convention
- Add comments explaining the query purpose
- Include business insights as comments
- Test queries before committing

#### Improving Documentation
- Use clear, concise language
- Add examples where helpful
- Maintain consistent formatting
- Check for typos and grammar

#### Adding Visualizations
- Use appropriate chart types
- Include data source information
- Add interpretation of insights
- Keep file sizes reasonable

### 4. Commit Your Changes
```bash
git add .
git commit -m "Brief description of changes"
```

**Commit Message Guidelines:**
- Use present tense ("Add feature" not "Added feature")
- Be specific and descriptive
- Reference issues if applicable

Examples:
```
✅ Good: "Add query for customer retention analysis"
✅ Good: "Fix syntax error in delivery analysis query"
❌ Bad: "Update files"
❌ Bad: "Changes"
```

### 5. Push and Create Pull Request
```bash
git push origin feature/your-feature-name
```

Then:
1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Provide clear description of changes
4. Submit for review

---

## Contribution Ideas

### SQL Queries
- [ ] Customer retention analysis
- [ ] Product recommendation logic
- [ ] Seller performance metrics
- [ ] Advanced delivery optimization
- [ ] Customer segmentation queries
- [ ] Cohort analysis
- [ ] RFM (Recency, Frequency, Monetary) analysis

### Documentation
- [ ] Translation to Portuguese
- [ ] Video tutorials
- [ ] Case study examples
- [ ] Best practices guide
- [ ] FAQ section

### Visualizations
- [ ] Tableau dashboards
- [ ] Power BI reports
- [ ] Python visualization notebooks
- [ ] Interactive web dashboards

### Tools & Automation
- [ ] Python scripts for data processing
- [ ] Automated report generation
- [ ] Data quality checks
- [ ] Query performance optimization

---

## Code Style Guidelines

### SQL
```sql
-- Use uppercase for SQL keywords
SELECT 
    customer_id,
    order_date,
    COUNT(*) AS total_orders
FROM dataset.orders
WHERE order_status = 'delivered'
GROUP BY customer_id, order_date
ORDER BY total_orders DESC;

-- Add comments for complex logic
-- Calculate customer lifetime value using 12-month window
WITH customer_orders AS (
    ...
)
```

### Markdown
- Use headers hierarchically (# > ## > ###)
- Add blank lines between sections
- Use tables for structured data
- Include code blocks with language tags

---

## Testing

### Before Submitting:
- [ ] Test all SQL queries in BigQuery
- [ ] Verify queries return expected results
- [ ] Check for syntax errors
- [ ] Ensure queries are optimized
- [ ] Update documentation if needed
- [ ] Run spelling/grammar check

---

## Review Process

1. **Initial Review** (1-2 days)
   - Maintainer checks basic requirements
   - Provides initial feedback

2. **Discussion** (as needed)
   - Discuss approach and implementation
   - Request changes if necessary

3. **Approval & Merge** (1-2 days after approval)
   - Maintainer approves PR
   - Changes merged to main branch

---

## Questions?

- Open an issue for discussion
- Tag maintainer for urgent questions
- Check existing issues/PRs first

---

## Code of Conduct

### Our Standards
- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the project
- Show empathy towards others

### Unacceptable Behavior
- Harassment or discrimination
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation

Thank you for contributing! 🎉
