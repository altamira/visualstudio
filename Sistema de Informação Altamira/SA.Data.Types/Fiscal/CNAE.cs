using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

namespace SA.Data.Types.Fiscal
{
    [Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, IsByteOrdered = true, MaxByteSize = 32, ValidationMethodName = "Validate")]
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    //[CLSCompliant(false)]
    public sealed class CNAE : INullable, IBinarySerialize
    {
        private string codigo;

        private const int CodigoMaxByteSize = 32;

        #region Constructor

        public CNAE()
        {
            codigo = "?";
        }

        public CNAE(string Codigo)
        {
            codigo = Codigo;
        }

        #endregion

        #region IsNull
        private bool isNull = true;

        public bool IsNull { get { return (isNull); } }

        public static CNAE Null { get { return new CNAE(); } }

        #endregion

        #region Parse And String

        [SqlMethod(OnNullCall = false)]
        public static CNAE Parse(SqlString s)
        {
            if (s.IsNull)
                return Null;

            // Parse input String to separate out points.
            CNAE g = new CNAE(s.ToString().Trim());

            //String[] xy = s.Value.Split(" ".ToCharArray());
            //u.Valor = Int32.Parse(xy[0]);
            //u.Unidade = new Unidade(Int32.Parse(xy[1]));

            //if (!u.Validate())
            //    throw new ArgumentException("Invalid value.");

            return g;
        }

        public override string ToString()
        {
            if (this.IsNull)
                return "NULL";
            else
            {
                StringBuilder builder = new StringBuilder();
                //builder.Append(valor.ToString());
                //.Append(" ");
                //builder.Append(unidade.ToString());
                return builder.ToString();
            }
        }
        #endregion

        #region Validate e Compare

        private bool Validate()
        {
            //if (validation logic here)
            return true;
            //else
            //    return false;
        }

        public override bool Equals(object o)
        {
            // If parameter is null return false.
            if (o == null)
            {
                return false;
            }

            // If parameter cannot be cast to Point return false.
            CNAE g = o as CNAE;
            if ((System.Object)g == null)
            {
                return false;
            }

            if (g.Codigo == this.Codigo)
                return true;
            else
                return false;
        }

        public override int GetHashCode()
        {
            return Codigo.GetHashCode();
        }

        #endregion

        #region Properties

        public string Codigo
        {
            get { return codigo; }
        }

        #endregion

        #region Serialize

        public void Write(System.IO.BinaryWriter w)
        {
            String padded = codigo.PadRight(CodigoMaxByteSize, '\0');
            for (int i = 0; i < CodigoMaxByteSize; i++)
            {
                w.Write(padded[i]);
            }
        }

        public void Read(System.IO.BinaryReader r)
        {
            //int id = r.ReadInt32();
            char[] CharCodigo = r.ReadChars(CodigoMaxByteSize);
            int stringEnd = Array.IndexOf(CharCodigo, '\0');

            if (stringEnd == 0)
            {
                CharCodigo = null;
                return;
            }

            codigo = new String(CharCodigo, 0, stringEnd);
        }

        #endregion

        #region Lookup

        private bool Lookup(string Codigo)
        {
            codigo = Codigo;
            isNull = false;
            return true;
        }

        #endregion
    }
}
