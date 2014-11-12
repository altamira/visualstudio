using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;

namespace SA.WpfCustomControlLibrary
{
    /// <summary>
    /// Class for crosstabbing/pivoting a list of objects
    /// </summary>
    /// <typeparam name="T">The type of object to pivot</typeparam>
    public class PivotTable<T>
        where T : class, new()
    {
        #region Private member variables

        private PropertyInfo _columnProperty;
        private PropertyInfo _valueProperty;
        private PropertyInfo _rowProperty;
        private string _rowSourceHeader;

        #endregion

        #region Constructor

        /// <summary>
        /// Creates a new instance of this class with the given row, column, and value settings
        /// </summary>
        /// <param name="rowSource">The name of the field in type <typeparamref name="T"/> to use for the row headings in the pivot</param>
        /// <param name="columnSource">The name of the field in type <typeparamref name="T"/> to use for the columns headings in the pivot</param>
        /// <param name="valueSource">The name of the field in type <typeparamref name="T"/> to use for the values in the pivot</param>
        /// <exception cref="System.ArgumentNullException">Thrown if any of the arguments are null, empty, or whitespace only</exception>
        /// <exception cref="System.ArgumentOutOfRangeException">Thrown if any of the values used for pivot fields do not exist in type <typeparamref name="T"/></exception>
        public PivotTable(string rowSource, string columnSource, string valueSource) :
            this(rowSource, rowSource, columnSource, valueSource)
        { }

        /// <summary>
        /// Creates a new instance of this class with the given row, column, and value settings
        /// </summary>
        /// <param name="rowSource">The name of the field in type <typeparamref name="T"/> to use for the row headings in the pivot</param>
        /// <param name="rowSourceHeader">The caption to use for the row heading of the row pivot</param>
        /// <param name="columnSource">The name of the field in type <typeparamref name="T"/> to use for the columns headings in the pivot</param>
        /// <param name="valueSource">The name of the field in type <typeparamref name="T"/> to use for the values in the pivot</param>
        /// <exception cref="System.ArgumentNullException">Thrown if any of the arguments are null, empty, or whitespace only</exception>
        /// <exception cref="System.ArgumentOutOfRangeException">Thrown if any of the values used for pivot fields do not exist in type <typeparamref name="T"/></exception>
        public PivotTable(string rowSource, string rowSourceHeader,
            string columnSource, string valueSource)
        {
            ThrowExceptionIfFieldNullOrEmpty("rowSource", rowSource);
            ThrowExceptionIfFieldNullOrEmpty("rowSourceHeader", rowSourceHeader);
            ThrowExceptionIfFieldNullOrEmpty("columnSource", columnSource);
            ThrowExceptionIfFieldNullOrEmpty("valueSource", valueSource);

            _rowSourceHeader = rowSourceHeader;
            _columnProperty = typeof(T).GetProperty(columnSource);

            if (_columnProperty == null)
            {
                ThrowExceptionIfFieldNotExists("columnSource", typeof(T), columnSource);
            }

            _valueProperty = typeof(T).GetProperty(valueSource);

            if (_valueProperty == null)
            {
                ThrowExceptionIfFieldNotExists("valueSource", typeof(T), valueSource);
            }

            _rowProperty = typeof(T).GetProperty(rowSource);

            if (_rowProperty == null)
            {
                ThrowExceptionIfFieldNotExists("rowSource", typeof(T), rowSource);
            }
        }

        #endregion

        #region Public methods

        public DataTable CreatePivot(IList<T> source)
        {
            if (source == null)
            {
                throw new ArgumentNullException("source");
            }

            var pivotTable = new DataTable();

            CreatePivotColumns(source, pivotTable, _columnProperty,
                _valueProperty, _rowProperty);

            AddPivotRows(source, pivotTable, _columnProperty,
                _valueProperty, _rowProperty);

            return pivotTable;
        }

        public ObservableCollection<T> Unpivot(DataTable table)
        {
            if (table == null)
            {
                throw new ArgumentNullException("table");
            }

            var unpivotedData = new ObservableCollection<T>();

            foreach (DataRow row in table.Rows)
            {
                foreach (DataColumn column in table.Columns)
                {
                    if (column.ColumnName != _rowProperty.Name)
                    {
                        var dataItem = CreateObjectFromRowColumn(row, column);
                        unpivotedData.Add(dataItem);
                    }
                }
            }

            return unpivotedData;
        }

        #endregion

        #region Private methods

        private void AddPivotRows(IList<T> source, DataTable pivotTable, PropertyInfo columnProperty,
            PropertyInfo valueProperty, PropertyInfo rowProperty)
        {
            var rows = (from s in source
                        select rowProperty.GetValue(s, null)).Distinct();

            foreach (var row in rows)
            {
                var newRow = pivotTable.NewRow();
                newRow[rowProperty.Name] = Convert.ChangeType(row, rowProperty.PropertyType);

                foreach (var sourceRow in source)
                {
                    object rowValue = rowProperty.GetValue(sourceRow, null);

                    if (rowValue != null && rowValue.ToString() == row.ToString())
                    {
                        string columnName = columnProperty.GetValue(sourceRow, null).ToString();
                        columnName = GetCleanColumnName(columnName);

                        var columnValue = valueProperty.GetValue(sourceRow, null);

                        if (columnValue == null)
                        {
                            columnValue = DBNull.Value;
                        }

                        newRow[columnName] = columnValue;
                    }
                }

                pivotTable.Rows.Add(newRow);
            }
        }

        private void CreatePivotColumns(IList<T> source, DataTable pivotTable,
            PropertyInfo columnProperty, PropertyInfo valueProperty, PropertyInfo rowProperty)
        {
            var columns = (from s in source
                           select columnProperty.GetValue(s, null).ToString()).Distinct();

            Type rowColumnType = GetUnderlyingPrimitive(rowProperty.PropertyType);
            pivotTable.Columns.Add(rowProperty.Name, rowColumnType);
            pivotTable.Columns[rowProperty.Name].Caption = _rowSourceHeader;

            foreach (var column in columns)
            {
                Type columnType = GetUnderlyingPrimitive(valueProperty.PropertyType);

                string columnName = GetCleanColumnName(column);
                pivotTable.Columns.Add(columnName, columnType);
                pivotTable.Columns[columnName].Caption = column;
            }
        }

        private T CreateObjectFromRowColumn(DataRow row, DataColumn column)
        {
            var dataItem = new T();

            _rowProperty.SetValue(dataItem, row[_rowProperty.Name], null);
            _columnProperty.SetValue(dataItem, column.Caption, null);

            bool isNullable = IsNullable(_valueProperty.PropertyType);

            if (row[column.ColumnName] == DBNull.Value /*&& isNullable*/)
            {
                _valueProperty.SetValue(dataItem, null, null);
            }
            else
            {
                _valueProperty.SetValue(dataItem, row[column.ColumnName], null);
            }

            return dataItem;
        }

        private void ThrowExceptionIfFieldNullOrEmpty(string argumentName, string argument)
        {
            if (string.IsNullOrEmpty(argument) || argument.Trim() == string.Empty)
            {
                throw new ArgumentNullException(argumentName);
            }
        }

        private void ThrowExceptionIfFieldNotExists(string argumentName,
            Type type, string fieldName)
        {
            throw new ArgumentOutOfRangeException(argumentName,
                string.Format("The field '{0}' does not exist in the '{1}' class",
                fieldName, type.Name));
        }

        private string GetCleanColumnName(string columnName)
        {
            string cleanColumnName = Regex.Replace(columnName, @"[^\w]", @"_");

            if (!Regex.IsMatch(cleanColumnName, @"^[a-zA-Z_]\w*$"))
            {
                cleanColumnName = string.Concat(@"_", cleanColumnName);
            }

            return cleanColumnName;
        }

        private bool IsNullable(Type type)
        {
            bool isNullable = (type.IsGenericType &&
                type.GetGenericTypeDefinition() == typeof(Nullable<>));
            return isNullable;
        }

        private Type GetUnderlyingPrimitive(Type type)
        {
            if (IsNullable(type))
            {
                return Nullable.GetUnderlyingType(type);
            }

            return type;
        }

        #endregion
    }
}
