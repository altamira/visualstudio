CREATE TABLE [dbo].[VE_SituaçãoDoRecado] (
    [vesi_CodSituaçãoDoRecado] SMALLINT     NOT NULL,
    [vesi_SituaçãoDoRecado]    VARCHAR (30) NULL,
    CONSTRAINT [PK_VE_SituaçãoDosRecados] PRIMARY KEY NONCLUSTERED ([vesi_CodSituaçãoDoRecado] ASC) WITH (FILLFACTOR = 90)
);

