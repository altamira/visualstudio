CREATE TABLE [dbo].[Agenda_Cliente_Entrega] (
    [dt_agenda]                 DATETIME      NOT NULL,
    [cd_cliente]                INT           NOT NULL,
    [hr_inicio_entrega_cliente] VARCHAR (8)   NOT NULL,
    [hr_final_entrega_cliente]  VARCHAR (8)   NOT NULL,
    [nm_obs_entrega_cliente]    VARCHAR (100) NOT NULL,
    [cd_usuario]                INT           NOT NULL,
    [dt_usuario]                DATETIME      NOT NULL,
    [ic_efetuado_agenda]        CHAR (1)      NULL,
    CONSTRAINT [PK_Agenda_Cliente_Entrega] PRIMARY KEY CLUSTERED ([dt_agenda] ASC, [cd_cliente] ASC) WITH (FILLFACTOR = 90)
);

