using System;
using System.Text;
using Microsoft.SqlServer.Server;
using System.Runtime.InteropServices;
using System.Data.SqlTypes;

namespace SA.Data.Types.Metrica
{
    [Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, IsByteOrdered = true, MaxByteSize = 32, ValidationMethodName = "Validate")]
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    //[CLSCompliant(false)]
    public sealed class Grandeza : INullable, IBinarySerialize
    {
        private string nome;

        private const int NameMaxByteSize = 32;

        #region Constructor

        public Grandeza()
        {
            nome = "?";
        }

        public Grandeza(string Nome)
        {
            if (!Lookup(Nome))
                throw new Exception("Grandeza inválida !");
        }

        #endregion

        #region IsNull
        private bool isNull = true;

        public bool IsNull { get { return (isNull); } }

        public static Grandeza Null { get { return new Grandeza(); } }

        #endregion

        #region Parse And String

        [SqlMethod(OnNullCall = false)]
        public static Grandeza Parse(SqlString s)
        {
            if (s.IsNull)
                return Null;

            // Parse input String to separate out points.
            Grandeza g = new Grandeza(s.ToString().Trim());

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
            Grandeza g = o as Grandeza;
            if ((System.Object)g == null)
            {
                return false;
            }

            if (g.Nome == this.Nome)
                return true;
            else
                return false;
        }

        public override int GetHashCode()
        {
            return Nome.GetHashCode();
        }

        #endregion

        #region Properties

        public string Nome
        {
            get { return nome; }
        }

        #endregion

        #region Serialize

        public void Write(System.IO.BinaryWriter w)
        {
            String padded = nome.PadRight(NameMaxByteSize, '\0');
            for (int i = 0; i < NameMaxByteSize; i++)
            {
                w.Write(padded[i]);
            }
        }

        public void Read(System.IO.BinaryReader r)
        {
            //int id = r.ReadInt32();
            char[] CharName = r.ReadChars(NameMaxByteSize);
            int stringEnd = Array.IndexOf(CharName, '\0');

            if (stringEnd == 0)
            {
                CharName = null;
                return;
            }

            nome = new String(CharName, 0, stringEnd);
        }

        #endregion

        #region Lookup

        private bool Lookup(string Nome)
        {
            nome = Nome;
            isNull = false;
            return true;
        }

        #endregion
    }
}
