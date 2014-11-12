CREATE TABLE [dbo].[Orgao_Multa] (
    [cd_orgao_multa]    INT          NOT NULL,
    [nm_orgao_multa]    VARCHAR (60) NULL,
    [nm_fantasia_orgao] VARCHAR (15) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Orgao_Multa] PRIMARY KEY CLUSTERED ([cd_orgao_multa] ASC) WITH (FILLFACTOR = 90)
);

