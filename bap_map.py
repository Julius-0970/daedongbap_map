import pymysql

def access_menu(cursor, connection, menu_title, select_query):
    while True:
        print(f"\n{menu_title}")
        print("1. 조회")
        print("2. 추가")
        print("3. 수정")
        print("4. 삭제")
        print("5. 이전 메뉴로 돌아가기")
        choice = input("메뉴를 선택하세요: ")

        if choice == '1':
            # 조회
            cursor.execute(select_query)
            items = cursor.fetchall()
            for item in items:
                print(item)
                break ; 
                
        elif choice == '2':
        # 추가
            if menu_title == "사용자 정보":
                user_id = input("사용자 ID를 입력하세요: ")
                password = input("비밀번호를 입력하세요: ")
                name = input("이름을 입력하세요: ")
                age = int(input("나이를 입력하세요: "))
                gender = int(input("성별을 입력하세요 (남자: 0, 여자: 1): "))
                email = input("이메일을 입력하세요: ")

                # 데이터베이스에 추가
                insert_query = """
                INSERT INTO user (user_id, password, name, age, gender, email)
                VALUES (%s, %s, %s, %s, %s, %s)
                """
                user_data = (user_id, password, name, age, gender, email)
                cursor.execute(insert_query, user_data)
                connection.commit()
                print("사용자 정보가 추가되었습니다.")
                break ; 
            elif menu_title == "피드 정보":
                # 추가 예정.
                pass
        
        elif choice == '3':
            # 수정할 사용자 ID 입력
            user_id = input("수정할 사용자 ID를 입력하세요: ")
            
            # 수정할 필드 선택
            print("수정할 필드를 선택하세요:")
            print("1. 비밀번호")
            print("2. 이름")
            print("3. 나이")
            print("4. 성별")
            print("5. 이메일")
            field_choice = input("선택 (1-5): ")

            # 새 값 입력
            new_value = input("새 값을 입력하세요: ")

            # 필드에 따른 쿼리와 값 설정
            if field_choice == '1':
                update_query = "UPDATE user SET password = %s WHERE user_id = %s"
            elif field_choice == '2':
                update_query = "UPDATE user SET name = %s WHERE user_id = %s"
            elif field_choice == '3':
                new_value = int(new_value)  # 나이는 정수로 변환
                update_query = "UPDATE user SET age = %s WHERE user_id = %s"
            elif field_choice == '4':
                new_value = int(new_value)  # 성별은 정수로 변환
                update_query = "UPDATE user SET gender = %s WHERE user_id = %s"
            elif field_choice == '5':
                update_query = "UPDATE user SET email = %s WHERE user_id = %s"
            else:
                print("잘못된 선택입니다.")
                return

            # 데이터베이스 업데이트
            cursor.execute(update_query, (new_value, user_id))
            connection.commit()
            print("사용자 정보가 성공적으로 수정되었습니다.")
        elif choice == '4':
            # 삭제
            pass
        elif choice == '5':
            print("이전 메뉴로 돌아갑니다.")
            break
        else:
            print("올바른 메뉴를 선택하세요.")

def main():
    # 데이터베이스 연결 설정
    connection = pymysql.connect(
        host='localhost',
        user='root',
        password='0000',
        database='daedongbap_map',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )
    
    connection = pymysql.connect(
        host='localhost',          # MySQL 서버의 호스트 이름
        user='root',               # MySQL 사용자 이름
        password='0000',       # MySQL 사용자 비밀번호
        database='daedongbap_map', # 연결할 데이터베이스 이름
        charset='utf8mb4',         # 문자 집합 설정
        cursorclass=pymysql.cursors.DictCursor # 결과를 딕셔너리 형태로 반환
    )

    try:
        with connection.cursor() as cursor:
            while True:
                print("\n1. 사용자 정보 메뉴")
                print("2. 피드 정보 메뉴")
                print("3. 종료")
                choice = input("메뉴를 선택하세요: ")

                if choice == '1':
                    access_menu(cursor, connection,"사용자 정보", "SELECT * FROM user")
                elif choice == '2':
                    access_menu(cursor, connection, "피드 정보", "SELECT * FROM feed")
                elif choice == '3':
                    print("프로그램을 종료합니다.")
                    break
                else:
                    print("올바른 메뉴를 선택하세요.")

    finally:
        connection.close()

if __name__ == "__main__":
    main()
