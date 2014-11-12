CREATE TABLE [dbo].[Orgao_Portaria_Norma] (
    [cd_orgao]          INT          NOT NULL,
    [nm_orgao]          VARCHAR (60) NULL,
    [nm_fantasia_orgao] VARCHAR (15) NULL,
    [ds_orgao]          TEXT         NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Orgao_Portaria_Norma] PRIMARY KEY CLUSTERED ([cd_orgao] ASC) WITH (FILLFACTOR = 90)
);

