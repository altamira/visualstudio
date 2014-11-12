CREATE TABLE [dbo].[Peslog] (
    [peslog_codigo]  INT            NULL,
    [peslog_nr_seq]  INT            NOT NULL,
    [peslog_tipo]    NVARCHAR (6)   NULL,
    [peslog_data]    DATETIME       NULL,
    [peslog_obs]     NVARCHAR (255) NULL,
    [peslog_usuario] NVARCHAR (12)  NULL
);

