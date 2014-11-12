using System;
using System.Text;
using System.Runtime.InteropServices;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

namespace SA.Data.Types.Fiscal
{
    [Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, IsByteOrdered = true, MaxByteSize = 32, ValidationMethodName = "Validate")]
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    //[CLSCompliant(false)]
    public sealed class InscricaoEstadual : INullable, IBinarySerialize
    {
        private string numero;

        private const int NumeroMaxByteSize = 32;

        #region Constructor

        public InscricaoEstadual()
        {
            numero = "?";
        }

        public InscricaoEstadual(string Numero)
        {
            numero = Numero;
        }

        #endregion

        #region IsNull
        private bool isNull = true;

        public bool IsNull { get { return (isNull); } }

        public static InscricaoEstadual Null { get { return new InscricaoEstadual(); } }

        #endregion

        #region Parse And String

        [SqlMethod(OnNullCall = false)]
        public static InscricaoEstadual Parse(SqlString s)
        {
            if (s.IsNull)
                return Null;

            // Parse input String to separate out points.
            InscricaoEstadual g = new InscricaoEstadual(s.ToString().Trim());

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
            InscricaoEstadual g = o as InscricaoEstadual;
            if ((System.Object)g == null)
            {
                return false;
            }

            if (g.Numero == this.Numero)
                return true;
            else
                return false;
        }

        public override int GetHashCode()
        {
            return Numero.GetHashCode();
        }

        #endregion

        #region Properties

        public string Numero
        {
            get { return numero; }
        }

        #endregion

        #region Serialize

        public void Write(System.IO.BinaryWriter w)
        {
            String padded = numero.PadRight(NumeroMaxByteSize, '\0');
            for (int i = 0; i < NumeroMaxByteSize; i++)
            {
                w.Write(padded[i]);
            }
        }

        public void Read(System.IO.BinaryReader r)
        {
            //int id = r.ReadInt32();
            char[] CharNumero = r.ReadChars(NumeroMaxByteSize);
            int stringEnd = Array.IndexOf(CharNumero, '\0');

            if (stringEnd == 0)
            {
                CharNumero = null;
                return;
            }

            numero = new String(CharNumero, 0, stringEnd);
        }

        #endregion

        #region Lookup

        private bool Lookup(string Numero)
        {
            numero = Numero;
            isNull = false;
            return true;
        }

        #endregion
    }
}
