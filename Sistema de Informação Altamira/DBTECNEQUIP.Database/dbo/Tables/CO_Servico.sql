CREATE TABLE [dbo].[CO_Servico] (
    [cose_Codigo]    TINYINT    NOT NULL,
    [cose_Descricao] CHAR (40)  NOT NULL,
    [cose_Lock]      ROWVERSION NOT NULL,
    CONSTRAINT [PK_CO_Servico_1__13] PRIMARY KEY CLUSTERED ([cose_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [cose_IDDescricao]
    ON [dbo].[CO_Servico]([cose_Descricao] ASC);

