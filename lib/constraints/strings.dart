const String dbName = "traidbiz_db";
const String appName = "Traidbiz";

const List<String> _productAttributes = ["Color", "Size"];
List<String> get productAttributes => _productAttributes;

const List<String> _productTypes = ["Simple", "Variable"];
List<String> get productTypes => _productTypes;

const List<String> _productFilters = [
  "Processing",
  "Pending",
  "Completed",
  "On-Hold"
];
List<String> get productFilters => _productFilters;
