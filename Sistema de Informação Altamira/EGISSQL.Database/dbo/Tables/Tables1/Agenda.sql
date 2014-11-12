CREATE TABLE [dbo].[Agenda] (
    [dt_agenda]           DATETIME     NOT NULL,
    [ic_util]             CHAR (1)     NOT NULL,
    [ic_plantao_vendas]   CHAR (1)     NOT NULL,
    [ic_financeiro]       CHAR (1)     NOT NULL,
    [ic_fiscal]           CHAR (1)     NOT NULL,
    [ic_fabrica_operacao] CHAR (1)     NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    [ic_financeira]       CHAR (1)     NULL,
    [nm_obs_agenda]       VARCHAR (40) NULL,
    CONSTRAINT [PK_Agenda] PRIMARY KEY CLUSTERED ([dt_agenda] ASC) WITH (FILLFACTOR = 90)
);

