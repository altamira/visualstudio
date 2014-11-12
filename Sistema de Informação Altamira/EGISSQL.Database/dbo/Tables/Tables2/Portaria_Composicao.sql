CREATE TABLE [dbo].[Portaria_Composicao] (
    [cd_portaria]            INT          NOT NULL,
    [cd_portaria_composicao] INT          NOT NULL,
    [cd_funcionario]         INT          NULL,
    [cd_turno]               INT          NULL,
    [ic_terceiro_portaria]   CHAR (1)     NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_usuario]             INT          NULL,
    [nm_obs_portaria]        VARCHAR (40) NULL,
    CONSTRAINT [PK_Portaria_Composicao] PRIMARY KEY CLUSTERED ([cd_portaria] ASC, [cd_portaria_composicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Portaria_Composicao_Turno] FOREIGN KEY ([cd_turno]) REFERENCES [dbo].[Turno] ([cd_turno])
);

