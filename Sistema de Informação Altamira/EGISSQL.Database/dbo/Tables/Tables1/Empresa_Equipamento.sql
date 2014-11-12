CREATE TABLE [dbo].[Empresa_Equipamento] (
    [cd_empresa]           INT          NOT NULL,
    [cd_planta]            INT          NOT NULL,
    [cd_equipamento]       INT          NOT NULL,
    [cd_departamento]      INT          NOT NULL,
    [nm_obs_empresa_equip] VARCHAR (40) NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL,
    CONSTRAINT [PK_Empresa_Equipamento] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_planta] ASC, [cd_equipamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Empresa_Equipamento_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

