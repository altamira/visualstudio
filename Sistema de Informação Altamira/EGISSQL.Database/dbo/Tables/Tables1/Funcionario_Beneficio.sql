CREATE TABLE [dbo].[Funcionario_Beneficio] (
    [cd_funcionario]      INT          NOT NULL,
    [cd_beneficio]        INT          NOT NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [dt_inicio_beneficio] DATETIME     NULL,
    [vl_beneficio]        FLOAT (53)   NULL,
    [nm_obs_beneficio]    VARCHAR (40) NULL,
    CONSTRAINT [PK_Funcionario_Beneficio] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC, [cd_beneficio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Beneficio_Beneficio] FOREIGN KEY ([cd_beneficio]) REFERENCES [dbo].[Beneficio] ([cd_beneficio])
);

