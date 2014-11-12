CREATE TABLE [dbo].[Tipo_Orcamento] (
    [cd_tipo_orcamento] INT          NOT NULL,
    [nm_tipo_orcamento] VARCHAR (30) NOT NULL,
    [sg_tipo_orcamento] CHAR (10)    NOT NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Orcamento] PRIMARY KEY NONCLUSTERED ([cd_tipo_orcamento] ASC) WITH (FILLFACTOR = 90)
);

