using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace SA.Web.Application.Lib.DBExtendedProperties
{
    public class SQLExtendedProperties : ConfigurationSection
    {
        public static SQLExtendedProperties LoadBySectionName()
        {
            return ConfigurationManager.GetSection("SQLExtendedProperties")  as SQLExtendedProperties;
        }

        [ConfigurationProperty("connection", IsRequired = true)]
        public string connection
        {
            get { return (string)this["connection"]; }
            set { this["connection"] = value; }
        }

        [ConfigurationProperty("version", IsRequired = true)]
        public string version
        {
            get { return (string)this["version"]; }
            set { this["version"] = value; }
        }
    }

    public static class ExtendedProperty
    {
        private static void ExtendedPropertTest(SqlConnection connection, string PropertyName)
        {
            using (var _command = new SqlCommand("sys.sp_ExtendedPropertTest", connection))
            {
                _command.CommandType = CommandType.StoredProcedure;
                SqlCommandBuilder.DeriveParameters(_command);
                _command.Parameters["@name"].Value = PropertyName;
                _command.ExecuteNonQuery();
            }
        }


        private static string GetExtendedPropertyValue(SqlConnection connection, string PropertyName)
        {
            string _version;
            using (var _command = new SqlCommand(String.Format("select value from sys.extended_properties where name = '{0}'", PropertyName), connection))
            {
                var _reader = _command.ExecuteReader();
                _reader.Read();
                _version = _reader.GetString(0);
                _reader.Close();
                return _version;
            }
        }

        private static void AddExtendedProperty(SqlConnection connection, string PropertyName)
        {
            var _command = new SqlCommand("sys.sp_addextendedproperty", connection);
            _command.CommandType = CommandType.StoredProcedure;

            SqlCommandBuilder.DeriveParameters(_command);

            _command.Parameters["@name"].Value = PropertyName;
            _command.Parameters["@value"].Value = SQLExtendedProperties.LoadBySectionName().version;

            _command.ExecuteNonQuery();

        }


        private static void UpdateExtendedProperty(SqlConnection connection, string PropertyName, string PropertyValue)
        {
            using (var _command = new
            SqlCommand("sys.sp_updateextendedproperty", connection))
            {
                _command.CommandType = CommandType.StoredProcedure;
                SqlCommandBuilder.DeriveParameters(_command);
                _command.Parameters["@name"].Value = PropertyName;
                _command.Parameters["@value"].Value = PropertyValue;
                _command.ExecuteNonQuery();
            }

        }

        private static SqlConnection GetConnection()
        {
            var local_conn = new
            SqlConnection(SQLExtendedProperties.LoadBySectionName().connection);
            local_conn.Open();
            return local_conn;
        }

        /*
         List 2:
 
        [Test]
        public void can_retrieve_version_value_from_config_file()
        {
          var _version = SQLExtendedProperties.LoadBySectionName().version;
          Assert.AreEqual("1.0.0", _version);
        }
 
         [Test]
        public void can_open_and_close_dblocal_conn()
        {
          var local_conn = GetConnection();
          Assert.AreEqual(ConnectionState.Open, local_conn.State);
 
          local_conn.Close();
          Assert.AreEqual(ConnectionState.Closed, local_conn.State);
         }
 
         [Test]
        public void can_create_extended_property()
        {
          var local_conn = GetConnection();
          AddExtendedProperty(local_conn, "Version");
 
          Assert.AreEqual(SQLExtendedProperties.LoadBySectionName().version,
           GetExtendedPropertyValue(local_conn,"Version"));
 
          ExtendedPropertTest(local_conn,"Version");
 
          local_conn.Close();
 
        }
 
         [Test]
        public void can_update_extended_property()
        {
         var local_conn = GetConnection();
 
         AddExtendedProperty(local_conn, "Version");
 
         UpdateExtendedProperty(local_conn, "Version","2.0.0");
 
         Assert.AreEqual("2.0.0", GetExtendedPropertyValue(local_conn, 
          "Version"));
 
        ExtendedPropertTest(local_conn, "Version");
 
        local_conn.Close();
 
        }
         * */
    }
}