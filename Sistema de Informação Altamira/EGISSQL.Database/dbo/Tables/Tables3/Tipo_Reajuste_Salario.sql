CREATE TABLE [dbo].[Tipo_Reajuste_Salario] (
    [cd_tipo_reajuste_salario] INT          NOT NULL,
    [nm_tipo_reajuste_salario] VARCHAR (30) NOT NULL,
    [sg_tipo_reajuste_salario] CHAR (10)    NOT NULL,
    [dt_tipo_reajuste_salario] DATETIME     NULL,
    [pc_tipo_reajuste_salario] FLOAT (53)   NULL,
    [nm_obs_reajuste_salario]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Reajuste_Salario] PRIMARY KEY CLUSTERED ([cd_tipo_reajuste_salario] ASC) WITH (FILLFACTOR = 90)
);

