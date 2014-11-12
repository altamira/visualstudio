CREATE TABLE [dbo].[Usuario_Hierarquia_Acesso] (
    [cd_controle_usuario] INT          NOT NULL,
    [cd_usuario_origem]   INT          NOT NULL,
    [cd_usuario_destino]  INT          NOT NULL,
    [nm_obs_hierarquia]   VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Usuario_Hierarquia_Acesso] PRIMARY KEY CLUSTERED ([cd_controle_usuario] ASC) WITH (FILLFACTOR = 90)
);

