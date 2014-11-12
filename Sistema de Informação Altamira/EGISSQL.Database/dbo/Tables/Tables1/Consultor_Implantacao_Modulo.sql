CREATE TABLE [dbo].[Consultor_Implantacao_Modulo] (
    [cd_consultor]            INT          NOT NULL,
    [cd_modulo]               INT          NOT NULL,
    [nm_obs_modulo_consultor] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Consultor_Implantacao_Modulo] PRIMARY KEY CLUSTERED ([cd_consultor] ASC, [cd_modulo] ASC) WITH (FILLFACTOR = 90)
);

