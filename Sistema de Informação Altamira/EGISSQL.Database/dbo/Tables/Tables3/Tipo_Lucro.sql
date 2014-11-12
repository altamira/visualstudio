CREATE TABLE [dbo].[Tipo_Lucro] (
    [cd_tipo_lucro]         INT          NOT NULL,
    [nm_tipo_lucro]         VARCHAR (30) NOT NULL,
    [sg_tipo_lucro]         CHAR (10)    NOT NULL,
    [pc_tipo_lucro]         FLOAT (53)   NOT NULL,
    [ic_servico_tipo_lucro] CHAR (1)     NULL,
    [nm_obs_tipo_lucro]     VARCHAR (50) NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    [ic_formula_tipo_lucro] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Lucro] PRIMARY KEY CLUSTERED ([cd_tipo_lucro] ASC) WITH (FILLFACTOR = 90)
);

