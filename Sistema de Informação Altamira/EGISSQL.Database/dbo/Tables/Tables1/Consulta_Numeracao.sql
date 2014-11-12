CREATE TABLE [dbo].[Consulta_Numeracao] (
    [cd_controle]         INT      NOT NULL,
    [cd_consulta]         INT      NULL,
    [cd_identificacao]    INT      NULL,
    [cd_tipo_proposta]    INT      NULL,
    [cd_usuario_consulta] INT      NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    CONSTRAINT [PK_Consulta_Numeracao] PRIMARY KEY CLUSTERED ([cd_controle] ASC)
);

