CREATE TABLE [dbo].[Status_Pos_Venda] (
    [cd_status_pos_venda] INT          NOT NULL,
    [nm_status_pos_venda] VARCHAR (40) NULL,
    [sg_status_pos_venda] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Status_Pos_Venda] PRIMARY KEY CLUSTERED ([cd_status_pos_venda] ASC) WITH (FILLFACTOR = 90)
);

