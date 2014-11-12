CREATE TABLE [dbo].[Semana_Ano] (
    [cd_semana_ano]     INT          NOT NULL,
    [dt_inicial_semana] DATETIME     NOT NULL,
    [dt_final_semana]   DATETIME     NOT NULL,
    [nm_obsevacao]      VARCHAR (50) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Semana_Ano] PRIMARY KEY CLUSTERED ([cd_semana_ano] ASC, [dt_inicial_semana] ASC, [dt_final_semana] ASC) WITH (FILLFACTOR = 90)
);

