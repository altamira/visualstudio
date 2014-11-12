CREATE TABLE [dbo].[SPED_Plano_Referencial] (
    [cd_plano]           INT           NOT NULL,
    [cd_tipo_plano]      INT           NULL,
    [cd_mascara_conta]   VARCHAR (50)  NULL,
    [nm_conta]           VARCHAR (150) NULL,
    [dt_inicio_validade] DATETIME      NULL,
    [dt_fim_validade]    DATETIME      NULL,
    [ic_tipo_conta]      CHAR (1)      NULL,
    [ds_conta]           TEXT          NULL,
    [cd_usuario]         INT           NULL,
    [dt_usuario]         DATETIME      NULL,
    [cd_interface]       INT           NULL,
    CONSTRAINT [PK_SPED_Plano_Referencial] PRIMARY KEY CLUSTERED ([cd_plano] ASC),
    CONSTRAINT [FK_SPED_Plano_Referencial_SPED_Tipo_Plano] FOREIGN KEY ([cd_tipo_plano]) REFERENCES [dbo].[SPED_Tipo_Plano] ([cd_tipo_plano])
);

