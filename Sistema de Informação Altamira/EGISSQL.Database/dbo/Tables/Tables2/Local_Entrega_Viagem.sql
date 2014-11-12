CREATE TABLE [dbo].[Local_Entrega_Viagem] (
    [cd_local_entrega_viagem] INT          NOT NULL,
    [nm_local_entrega_viagem] VARCHAR (40) NULL,
    [sg_local_entrega_viagem] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_pad_local_entrega]    CHAR (1)     NULL,
    CONSTRAINT [PK_Local_Entrega_Viagem] PRIMARY KEY CLUSTERED ([cd_local_entrega_viagem] ASC) WITH (FILLFACTOR = 90)
);

