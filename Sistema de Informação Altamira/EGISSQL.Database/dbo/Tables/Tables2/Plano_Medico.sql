CREATE TABLE [dbo].[Plano_Medico] (
    [cd_plano_medico]     INT          NOT NULL,
    [nm_plano_medico]     VARCHAR (60) NULL,
    [cd_convenio]         INT          NULL,
    [vl_plano_medico]     FLOAT (53)   NULL,
    [nm_obs_plano_medico] VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Plano_Medico] PRIMARY KEY CLUSTERED ([cd_plano_medico] ASC),
    CONSTRAINT [FK_Plano_Medico_Convenio_Medico] FOREIGN KEY ([cd_convenio]) REFERENCES [dbo].[Convenio_Medico] ([cd_convenio])
);

