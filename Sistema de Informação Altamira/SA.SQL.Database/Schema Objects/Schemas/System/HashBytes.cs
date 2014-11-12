//------------------------------------------------------------------------------
// <copyright file="CSSqlFunction.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Security.Cryptography;
using System.Text;
using Microsoft.SqlServer.Server;

namespace System
{
    public partial class UserDefinedFunctions
    {
        [Microsoft.SqlServer.Server.SqlFunction(Name="System.Hash.String")]
        public static SqlBinary SystemHashString(SqlString algorithmName, SqlString stringToHash)
        {
            var algorithm = HashAlgorithm.Create(algorithmName.Value);

            var bytes = Encoding.UTF8.GetBytes(stringToHash.Value);

            return new SqlBinary(algorithm.ComputeHash(bytes));
        }

        [Microsoft.SqlServer.Server.SqlFunction(Name="System.Hash.Bytes")]
        public static SqlBinary SystemHashBytes(SqlString algorithmName, SqlBinary bytesToHash)
        {
            var algorithm = HashAlgorithm.Create(algorithmName.Value);

            //var bytes = Encoding.UTF8.GetBytes(data.Value);

            return new SqlBinary(algorithm.ComputeHash(bytesToHash.Value));
        }
    }
}
