CREATE TABLE [dbo].[SI_Usuario] (
    [sius_Codigo]       INT          NOT NULL,
    [sius_Nome]         CHAR (20)    NOT NULL,
    [sius_NomeCompleto] VARCHAR (40) NOT NULL,
    [sius_Senha]        CHAR (45)    NULL,
    [sius_Departamento] VARCHAR (20) NOT NULL,
    [sius_Lock]         ROWVERSION   NOT NULL,
    CONSTRAINT [PK_SI_Usuario] PRIMARY KEY NONCLUSTERED ([sius_Codigo] ASC) WITH (FILLFACTOR = 90)
);

