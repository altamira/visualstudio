CREATE TABLE [dbo].[Prefeitura] (
    [cd_prefeitura]      INT           NOT NULL,
    [nm_prefeitura]      VARCHAR (60)  NULL,
    [cd_site_prefeitura] VARCHAR (100) NULL,
    [cd_ddd_prefeitura]  VARCHAR (4)   NULL,
    [cd_fone_prefeitura] VARCHAR (15)  NULL,
    [cd_usuario]         INT           NULL,
    [dt_usuario]         DATETIME      NULL,
    CONSTRAINT [PK_Prefeitura] PRIMARY KEY CLUSTERED ([cd_prefeitura] ASC) WITH (FILLFACTOR = 90)
);

