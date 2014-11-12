CREATE TABLE [dbo].[Profissao] (
    [cd_profissao]          INT          NOT NULL,
    [nm_profissao]          VARCHAR (40) NULL,
    [nm_fantasia_profissao] VARCHAR (20) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ds_profissao]          TEXT         NULL,
    CONSTRAINT [PK_Profissao] PRIMARY KEY CLUSTERED ([cd_profissao] ASC) WITH (FILLFACTOR = 90)
);

