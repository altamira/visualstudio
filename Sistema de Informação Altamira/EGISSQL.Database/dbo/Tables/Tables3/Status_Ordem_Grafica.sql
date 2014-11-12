CREATE TABLE [dbo].[Status_Ordem_Grafica] (
    [cd_status_ordem] INT          NOT NULL,
    [nm_status_ordem] VARCHAR (40) NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Status_Ordem_Grafica] PRIMARY KEY CLUSTERED ([cd_status_ordem] ASC) WITH (FILLFACTOR = 90)
);

