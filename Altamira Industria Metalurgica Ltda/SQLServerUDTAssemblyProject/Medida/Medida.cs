using System;
using System.Text;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Runtime.InteropServices;

namespace SA.Data.Types.Metrica
{
    [System.Serializable]
    [Microsoft.SqlServer.Server.SqlUserDefinedAggregate(Format.UserDefined, MaxByteSize = 32)]
    [Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, IsByteOrdered = true, MaxByteSize = 32, ValidationMethodName = "Validate")]
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public sealed class Medida : INullable, IBinarySerialize
    {
        private Double valor = 0;
        private Unidade unidade;

        #region Constructor

        public Medida()
        {
            unidade = new Unidade();
        }

        public Medida(string Simbolo)
        {
            this.Unidade = new Unidade(Simbolo);
        }

        public Medida(Double Valor, string Simbolo)
        {
            this.Valor = Valor;
            this.Unidade = new Unidade(Simbolo);
        }

        public Medida(Double Valor, Unidade Unidade)
        {
            this.Valor = Valor;
            this.Unidade = new Unidade(Unidade.Simbolo);
        }

        #endregion

        #region IsNull
        private bool isNull = true;

        public bool IsNull { get { return (isNull); } }

        public static Medida Null { get { return new Medida(); } }

        #endregion

        #region Parse And String

        [SqlMethod(OnNullCall = false)]
        public static Medida Parse(SqlString s)
        {
            if (s.IsNull || s.Value.ToLower().Equals("null"))
                return Null;

            String[] values = s.Value.Split(" ".ToCharArray());

            if (values.Length != 2)
                return Null;

            Medida m = new Medida();

            try
            {
                m.valor = double.Parse(values[0].Trim());
            }
            catch (Exception)
            {
                throw new System.Data.SqlTypes.SqlTypeException("Valor inválido !");
                //return Null;
            }

            m.unidade = new Unidade(values[1].Trim());

            if (!m.Validate())
                throw new System.Data.SqlTypes.SqlTypeException("Medida inválida !");

            m.isNull = false;

            return m;
        }

        public override string ToString()
        {
            if (this.IsNull)
                return "NULL";
            else
            {
                StringBuilder builder = new StringBuilder();
                builder.Append(valor.ToString());
                builder.Append(" ");
                builder.Append(unidade.ToString());
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

        public Double Valor
        {
            get
            {
                return valor;
            }
            set
            {
                Double tmp = value;
                valor = value;
                if (!Validate())
                {
                    valor = tmp;
                    throw new System.Data.SqlTypes.SqlTypeException("Valor inválido !");
                }
                if (unidade != null)
                    if (!unidade.IsNull) isNull = false;
            }

        }

        public Unidade Unidade
        {
            get
            {
                return unidade;
            }
            set
            {
                Unidade tmp = value;
                unidade = value;
                if (!Validate())
                {
                    unidade = tmp;
                    throw new System.Data.SqlTypes.SqlTypeException("Unidade inválida !");
                }
                isNull = false;
            }
        }

        #endregion

        #region Methods And Calcules

        //[SqlMethod(OnNullCall = false, IsMutator=true)]
        //public void ConvertTo(Unidade Unidade)
        //{
        //    valor = valor * (Unidade.Fator / unidade.Fator);
        //    unidade = Unidade;
        //}

        [SqlMethod(OnNullCall = false)]
        public Medida ConvertTo(Unidade Unidade)
        {
            return new Medida(valor * (Unidade.Fator / unidade.Fator), Unidade);
        }

        [SqlMethod(OnNullCall = false)]
        public string ConvertToString(Unidade Unidade)
        {
            valor = valor * (Unidade.Fator / unidade.Fator);
            unidade = Unidade;
            return ToString();
        }

        [SqlMethod(OnNullCall = false)]
        public Medida Sum(Medida m)
        {
            if (unidade.Grandeza.Equals(m.Unidade.Grandeza))
            {
                valor += m.Valor;
            }
            return this;
        }
        #endregion

        #region Serialize

        public void Write(System.IO.BinaryWriter w)
        {
            w.Write((Double)valor);

            if (unidade == null)
                throw new System.Data.SqlTypes.SqlTypeException("Erro grave ao tentar gravar os dados da Medida: A Unidade de Medida é nulo !");

            if (unidade.IsNull)
                throw new System.Data.SqlTypes.SqlTypeException("Erro grave ao tentar gravar os dados da Medida: A Unidade de Medida não foi definida !");

            unidade.Write(w);
        }

        public void Read(System.IO.BinaryReader r)
        {
            valor = (Double)r.ReadDouble();
            unidade.Read(r);
            isNull = false;
        }

        #endregion

        #region Aggregate

        public void Init()
        {
        }

        public void Accumulate(Medida Medida)
        {
            if (Medida == null)
                return;

            if (Medida.IsNull)
                return;

            if (this.IsNull)
            {
                Valor = Medida.Valor;
                Unidade = new Unidade(Medida.Unidade.Simbolo);
            }
            else
            {
                Valor += Medida.Valor;
                if (unidade == null)
                    throw new System.Data.SqlTypes.SqlTypeException("Impossivel calcular porque a Unidade de Medida não foi definida !");
            }
        }

        public void Merge(Medida Group)
        {
            if (Group == null)
                return;

            Valor += Group.Valor;
        }

        public Medida Terminate()
        {
            //if (Soma == null)
            //    return new Medida();

            return this;
        }

        #endregion

        #region Compare
        //public static bool operator != (Medida A, Medida B)
        //{
        //    return true;
        //}
        #endregion
    }
}
