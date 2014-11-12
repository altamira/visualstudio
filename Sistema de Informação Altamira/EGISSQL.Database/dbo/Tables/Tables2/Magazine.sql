CREATE TABLE [dbo].[Magazine] (
    [cd_magazine]        INT          NOT NULL,
    [nm_magazine]        VARCHAR (50) NULL,
    [sg_magazine]        CHAR (10)    NULL,
    [cd_pos_processador] INT          NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Magazine] PRIMARY KEY CLUSTERED ([cd_magazine] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Magazine_Pos_Processador] FOREIGN KEY ([cd_pos_processador]) REFERENCES [dbo].[Pos_Processador] ([cd_pos_processador])
);

