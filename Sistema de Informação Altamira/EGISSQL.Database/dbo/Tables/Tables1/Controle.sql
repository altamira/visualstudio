CREATE TABLE [dbo].[Controle] (
    [cd_controle]         INT           NOT NULL,
    [nm_controle]         VARCHAR (40)  NULL,
    [ic_padrao_controle]  CHAR (1)      NULL,
    [nm_arquivo_controle] VARCHAR (100) NULL,
    [nm_site]             VARCHAR (100) NULL,
    [cd_usuario]          INT           NULL,
    [dt_usuario]          DATETIME      NULL,
    [ds_controle]         TEXT          NULL,
    CONSTRAINT [PK_Controle] PRIMARY KEY CLUSTERED ([cd_controle] ASC) WITH (FILLFACTOR = 90)
);

