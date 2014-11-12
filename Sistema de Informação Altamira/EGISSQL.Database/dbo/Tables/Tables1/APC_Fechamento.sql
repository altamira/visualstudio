CREATE TABLE [dbo].[APC_Fechamento] (
    [cd_controle_fechamento]  INT          NOT NULL,
    [cd_ano]                  INT          NOT NULL,
    [cd_mes]                  INT          NOT NULL,
    [dt_inicial_fechamento]   DATETIME     NULL,
    [dt_final_fechamento]     DATETIME     NULL,
    [qt_dia_prazo_fechamento] FLOAT (53)   NULL,
    [dt_envia_fechamento]     DATETIME     NULL,
    [nm_obs_fechamento]       VARCHAR (60) NULL,
    CONSTRAINT [PK_APC_Fechamento] PRIMARY KEY CLUSTERED ([cd_controle_fechamento] ASC),
    CONSTRAINT [FK_APC_Fechamento_Mes] FOREIGN KEY ([cd_mes]) REFERENCES [dbo].[Mes] ([cd_mes])
);

