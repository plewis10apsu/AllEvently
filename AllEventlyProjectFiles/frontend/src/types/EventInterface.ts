export interface Event {
    id: number;
    title: string;
    type: string;
    venue: string;
    date: string;
    time: string;
    host: string;
    imageUrl: string;
    venueLink: string;
    venueAddress: string;
    isHost?: boolean;
    isGuest?: boolean;
}