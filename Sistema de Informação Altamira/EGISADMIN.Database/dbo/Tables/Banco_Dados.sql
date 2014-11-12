CREATE TABLE [dbo].[Banco_Dados] (
    [cd_banco_dados]          INT           NOT NULL,
    [nm_banco_dados]          VARCHAR (40)  NULL,
    [nm_fantasia_banco_dados] VARCHAR (25)  NOT NULL,
    [ic_ativo_banco_dados]    CHAR (1)      NULL,
    [nm_caminho_banco_dados]  VARCHAR (100) NULL,
    [ds_banco_dados]          TEXT          NULL,
    [nm_obs_banco_dados]      VARCHAR (40)  NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    CONSTRAINT [PK_Banco_Dados] PRIMARY KEY CLUSTERED ([cd_banco_dados] ASC) WITH (FILLFACTOR = 90)
);

