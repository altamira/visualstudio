using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Runtime.InteropServices;

namespace SA.Data.Types.Metrica
{
    [Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, IsByteOrdered = true, MaxByteSize = 16, ValidationMethodName = "Validate")]
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public sealed class Unidade : INullable, IBinarySerialize
    {

        private Grandeza grandeza;
        private string simbolo;
        private string descricao;
        private Double fator; // fator de conversao

        private const int SimboloMaxByteSize = 8;

        #region Constructor

        public Unidade()
        {
            simbolo = "?";
            grandeza = new Grandeza();
        }
        
        public Unidade(string Simbolo)
        {
            if (!Lookup(Simbolo))
                throw new Exception("Unidade de Medida inválida !");
        }

        #endregion

        #region IsNull
        private bool isNull = true;

        public bool IsNull { get { return (isNull); } }

        public static Unidade Null { get { return new Unidade(); } }

        #endregion

        #region Parse And String

        [SqlMethod(OnNullCall = false)]
        public static Unidade Parse(SqlString s)
        {
            if (s.IsNull || s.Value.ToLower().Equals("null"))
                return Null;

            Unidade u;

            LookupTable.TryGetValue(s.ToString().Trim(), out u);
            
            if (!u.Validate())
                throw new ArgumentException("Esta Unidade inválida !");

            u.isNull = false;

            return u;
        }

        public override string ToString()
        {
            if (this.IsNull)
                return "NULL";
            else
            {
                StringBuilder builder = new StringBuilder();
                builder.Append(simbolo);
                return builder.ToString();
            }
        }
        #endregion

        #region Validate

        private bool Validate()
        {
            //if (validation logic here)
            return true;
            //else
            //    return false;
        }

        #endregion

        #region Properties

        public Grandeza Grandeza
        {
            get { return grandeza; }
        }

        public string Simbolo
        {
            get { return simbolo; }
            set 
            {
                if (Lookup(value))
                    simbolo = value;
                else
                    throw new Exception("Unidade de Medida inválida !");
            }
        }

        public string Descricao
        {
            get { return descricao; }
        }

        public Double Fator
        {
            get { return fator; }
        }

        #endregion

        #region Serialize

        public void Write(System.IO.BinaryWriter w)
        {
            //w.Write((Int32)id);
            String padded = simbolo.PadRight(SimboloMaxByteSize, '\0');
            for (int i = 0; i < SimboloMaxByteSize; i++)
            {
                w.Write(padded[i]);
            }

        }

        [Microsoft.SqlServer.Server.SqlFunction(DataAccess = DataAccessKind.Read, SystemDataAccess = SystemDataAccessKind.Read)]
        public void Read(System.IO.BinaryReader r)
        {
            //int id = r.ReadInt32();
            char[] CharSimbol = r.ReadChars(SimboloMaxByteSize);
            int stringEnd = Array.IndexOf(CharSimbol, '\0');

            if (stringEnd == 0)
            {
                CharSimbol = null;
                return;
            }

            string s = new String(CharSimbol, 0, stringEnd);

            if (!Lookup(s))
                throw new Exception("Unidade de Medida inválida armazenada no banco de dados !");

        }

        #endregion

        #region Lookup 

        // Fonte:
        // http://www.inmetro.gov.br/infotec/publicacoes/si_versao_final.pdf
        // http://www.convertworld.com/pt/
        private bool Lookup(string Simbolo)
        {
            Unidade u;

            if (LookupTable.TryGetValue(Simbolo, out u))
            {
                grandeza = u.Grandeza;
                simbolo = u.Simbolo;
                descricao = u.Descricao;
                fator = u.Fator;

                isNull = false;

                return true;
            }
            else
                throw new ArgumentException("Esta Unidade de Medida não existe !");

            //return false;
        }

        private static readonly Dictionary<string, Unidade> LookupTable = new Dictionary<string, Unidade>
        {
            // Massa
            { "t",  new Unidade()   { grandeza = new Grandeza("Peso"),     simbolo = "t",      descricao = "Tonelada",     fator = 0.001d             } },
            { "kN", new Unidade()   { grandeza = new Grandeza("Peso"),     simbolo = "kN",     descricao = "Kilonewton",   fator = 0.009806652d       } },
            { "kg", new Unidade()   { grandeza = new Grandeza("Peso"),     simbolo = "kg",     descricao = "kilograma",    fator = 1.0d               } },
            { "hg", new Unidade()   { grandeza = new Grandeza("Peso"),     simbolo = "hg",     descricao = "Hectograma",   fator = 10.0d              } },
            { "g",  new Unidade()   { grandeza = new Grandeza("Peso"),     simbolo = "g",      descricao = "Grama",        fator = 1000.0d            } },
            { "cg", new Unidade()   { grandeza = new Grandeza("Peso"),     simbolo = "cg",     descricao = "Centigrama",   fator = 100000.0d          } },
            { "mg", new Unidade()   { grandeza = new Grandeza("Peso"),     simbolo = "mg",     descricao = "Miligrama",    fator = 1000000.0d         } },
            { "µg", new Unidade()   { grandeza = new Grandeza("Peso"),     simbolo = "µg",     descricao = "Micrograma",   fator = 1000000000.0d      } },
            { "ng", new Unidade()   { grandeza = new Grandeza("Peso"),     simbolo = "ng",     descricao = "Nanograma",    fator = 1000000000000.0d   } },


        };

        #endregion

    }
}
