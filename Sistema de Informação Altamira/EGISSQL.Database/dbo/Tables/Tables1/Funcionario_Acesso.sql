CREATE TABLE [dbo].[Funcionario_Acesso] (
    [cd_funcionario]            INT          NOT NULL,
    [cd_area_acesso]            INT          NOT NULL,
    [nm_obs_funcionario_acesso] VARCHAR (40) NULL,
    [cd_usuario]                DATETIME     NULL,
    [dt_usuario]                INT          NULL,
    CONSTRAINT [PK_Funcionario_Acesso] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC, [cd_area_acesso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Acesso_Area_Acesso] FOREIGN KEY ([cd_area_acesso]) REFERENCES [dbo].[Area_Acesso] ([cd_area_acesso])
);

