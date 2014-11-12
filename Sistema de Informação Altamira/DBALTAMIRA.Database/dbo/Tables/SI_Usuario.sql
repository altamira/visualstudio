CREATE TABLE [dbo].[SI_Usuario] (
    [sius_Codigo]        INT          NOT NULL,
    [sius_Nome]          CHAR (50)    NOT NULL,
    [sius_NomeCompleto]  VARCHAR (40) NOT NULL,
    [sius_Senha]         CHAR (150)   NULL,
    [sius_Departamento]  VARCHAR (20) NOT NULL,
    [sius_PedidoInicial] INT          NULL,
    [sius_PedidoFinal]   INT          NULL,
    [sius_PedidoSeq]     INT          NULL,
    [sius_Gestao]        SMALLINT     NULL,
    [sius_Lock]          BINARY (8)   NULL,
    CONSTRAINT [PK_SI_Usuario] PRIMARY KEY NONCLUSTERED ([sius_Codigo] ASC) WITH (FILLFACTOR = 90)
);

