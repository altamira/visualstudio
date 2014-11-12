CREATE TABLE [dbo].[Variavel_Comando] (
    [dt_usuario]            DATETIME     NULL,
    [cd_usuario]            INT          NULL,
    [sg_sub_rotina_apl]     CHAR (15)    NULL,
    [cd_maquina]            INT          NULL,
    [cd_variavel]           INT          NOT NULL,
    [nm_variavel]           VARCHAR (50) NULL,
    [cd_parametro_variavel] CHAR (10)    NULL,
    CONSTRAINT [PK_Variavel_Comando] PRIMARY KEY CLUSTERED ([cd_variavel] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Variavel_Comando_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

