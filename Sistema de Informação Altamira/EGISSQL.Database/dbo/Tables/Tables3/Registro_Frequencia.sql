CREATE TABLE [dbo].[Registro_Frequencia] (
    [cd_registro_frequencia] INT          NOT NULL,
    [dt_registro_frequencia] DATETIME     NULL,
    [hr_entrada_registro]    VARCHAR (8)  NULL,
    [hr_saida_registro]      VARCHAR (8)  NULL,
    [cd_igreja]              INT          NULL,
    [cd_obreiro]             INT          NULL,
    [cd_pastor]              INT          NULL,
    [cd_membro]              INT          NULL,
    [cd_tipo_ausencia]       INT          NULL,
    [nm_obs_registro]        VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Registro_Frequencia] PRIMARY KEY CLUSTERED ([cd_registro_frequencia] ASC) WITH (FILLFACTOR = 90)
);

