# *SSIS Component Naming Playbook*

## 1. Naming Pattern

Use:

`[Component Type] | [Business/Technical Action] | [Object/Purpose]`

Examples:

- `DFT | Extract Product`
- `DER | Standardize ProductLine`
- `DER | Handle Null Color`
- `CNV | Product Attribute Types`
- `LKP | Map Product Category`
- `DST | Load dim.Product`

The name should describe **why the component exists**, not merely what type of component it is.

---

## 2. Data Flow Task (DFT)

Examples:

- `DFT | Extract Product`
- `DFT | Transform Product`
- `DFT | Load Product`
- `DFT | Stage to Transform Product`
- `DFT | Load Dim Product`

Prefer naming the Data Flow according to its primary purpose.

---

## 3. Source (SRC)

Examples:

- `SRC | Stage Product`
- `SRC | Extract Product`
- `SRC | Read stg.Product`

---

## 4. Destination (DST)

Examples:

- `DST | Load transform.Product`
- `DST | Load dim.Product`
- `DST | Load fact.Sales`

---

## 5. Derived Column (DER)

Name according to the transformation performed:

- `DER | Handle Null Attributes`
- `DER | Standardize Product Line`
- `DER | Normalize Product Color`
- `DER | Create Product Category`
- `DER | Clean Product Attributes`
- `DER | Standardize Product Attributes`

Avoid:

- `Derived Column 1`
- `Derived Column Product`
- `DC Product`

---

## 6. Data Conversion (CNV)

For type/length conversions:

- `CNV | Product Attributes`
- `CNV | Product Strings`
- `CNV | Date Attributes`
- `CNV | Numeric Attributes`
- `CNV | Product Attribute Types`

For a very specific conversion:

- `CNV | Color DT_WSTR(20)`
- `CNV | ProductLine DT_WSTR(10)`

---

## 7. Lookup (LKP)

Name according to the Lookup purpose:

- `LKP | Product Category`
- `LKP | Product Subcategory`
- `LKP | Customer`
- `LKP | Date`

For code-to-description mappings:

- `LKP | Map Product Line`
- `LKP | Map Product Style`
- `LKP | Map Product Class`

---

## 8. Conditional Split (SPL)

Name according to the business rule:

- `SPL | Valid vs Invalid Products`
- `SPL | Known vs Unknown ProductLine`
- `SPL | New vs Existing Products`
- `SPL | Valid Product Attributes`

---

## 9. Sort (SRT)

Examples:

- `SRT | Product Key`
- `SRT | Product ID`
- `SRT | Product Load Order`
- `SRT | Prepare Product for Merge Join`

---

## 10. Aggregate (AGG)

Examples:

- `AGG | Product Sales`
- `AGG | Daily Sales`
- `AGG | Customer Sales`
- `AGG | Deduplicate Product`

---

## 11. Merge / Merge Join (MRG)

Examples:

- `MRG | Product + Category`
- `MRG | Sales + Customer`
- `MRG | Product + Subcategory`

---

## 12. Row Count (CNT)

Examples:

- `CNT | Extracted Rows`
- `CNT | Transformed Rows`
- `CNT | Loaded Rows`
- `CNT | Rejected Rows`

Useful for ETL monitoring and debugging.

---

## 13. Execute SQL Task (SQL)

Name according to the SQL operation:

- `SQL | Truncate stg.Product`
- `SQL | Truncate transform.Product`
- `SQL | Initialize ETL`
- `SQL | Update ETL Metadata`
- `SQL | Validate Source`

Avoid:

- `Execute SQL Task 1`
- `Execute SQL Task 2`

---

## 14. Sequence Container (SEQ)

Examples:

- `SEQ | Extract`
- `SEQ | Transform`
- `SEQ | Load`
- `SEQ | Product Pipeline`
- `SEQ | Error Handling`

---

## 15. Parameters

Use concise, descriptive names:

- `NullString`
- `SourceConnectionString`
- `TargetConnectionString`
- `LoadDate`

---

## 16. Variables

Use descriptive names without repeating the `User::` scope prefix:

- `ExtractedRowCount`
- `RejectedRowCount`
- `ETLStartTime`