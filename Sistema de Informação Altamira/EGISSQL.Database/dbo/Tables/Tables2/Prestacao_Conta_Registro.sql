CREATE TABLE [dbo].[Prestacao_Conta_Registro] (
    [cd_prestacao]        INT          NOT NULL,
    [cd_usuario_registro] INT          NULL,
    [dt_registro]         DATETIME     NULL,
    [nm_obs_registro]     VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Prestacao_Conta_Registro] PRIMARY KEY CLUSTERED ([cd_prestacao] ASC)
);

