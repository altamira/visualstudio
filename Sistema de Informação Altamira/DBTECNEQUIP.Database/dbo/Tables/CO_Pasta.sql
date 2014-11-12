CREATE TABLE [dbo].[CO_Pasta] (
    [copt_Codigo]    TINYINT    NOT NULL,
    [copt_Descricao] CHAR (40)  NOT NULL,
    [copt_Lock]      ROWVERSION NOT NULL,
    CONSTRAINT [PK___1__13] PRIMARY KEY CLUSTERED ([copt_Codigo] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [copt_IDDescricao]
    ON [dbo].[CO_Pasta]([copt_Descricao] ASC);

