export default function PaginatedResponse<TItem>() {

  abstract class PaginatedResponseClass {

    result: TItem[];

    total: number;

    page: number;

    start: number;

    end: number;

    length: number;

    lastPage: number
  }

  return PaginatedResponseClass;

}