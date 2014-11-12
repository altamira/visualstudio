using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using SA.Data.Types.Metrica;

namespace SA.Data.Types
{
    [System.Serializable]
    [Microsoft.SqlServer.Server.SqlUserDefinedAggregate(Format.UserDefined, MaxByteSize = 32)]
    public sealed class Soma : INullable, IBinarySerialize
    {
        private SA.Data.Types.Metrica.Medida m = new SA.Data.Types.Metrica.Medida();

        public void Init()
        {
            m = new SA.Data.Types.Metrica.Medida();
        }

        public void Accumulate(SA.Data.Types.Metrica.Medida Medida)
        {
            if (Medida == null)
                return;

            if (Medida.IsNull)
                return;

            if (m.IsNull)
                m = new Medida(Medida.Valor, Medida.Unidade);
            else
                m.Valor += Medida.Valor;
        }

        public void Merge(Soma Group)
        {
            if (Group == null)
                return;

            m.Valor += Group.m.Valor;
        }

        public SA.Data.Types.Metrica.Medida Terminate()
        {
            if (m == null)
                return new SA.Data.Types.Metrica.Medida();

            return m;
        }

        #region IsNull
        private bool isNull = true;

        public bool IsNull { get { return (isNull); } }

        public static Medida Null { get { return new Medida(); } }

        #endregion

        #region Serialize

        public void Write(System.IO.BinaryWriter w)
        {
            m.Write(w);
        }

        public void Read(System.IO.BinaryReader r)
        {
            m.Read(r);
        }

        #endregion
    }
}
